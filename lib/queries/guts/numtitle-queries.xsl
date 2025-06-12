<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:dtea="http://itsurim.com/dtea"
    exclude-result-prefixes="dtea xs" version="2.0">


    <xsl:import href="basic-queries.xsl"/>


    <!-- 
        Titles
    -->

    <!-- Title label, e.g. Table 24 -->

    <xsl:template match="*" mode="dtea:title.hasLabel">
        <xsl:sequence select="false()"/>
    </xsl:template>

    <xsl:template match="*[@dtea:title-label]" mode="dtea:title.hasLabel">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:function name="dtea:title.hasLabel" as="xs:boolean">

        <xsl:param name="element"/>

        <xsl:apply-templates select="$element" mode="dtea:title.hasLabel"/>

    </xsl:function>


    <xsl:template match="*" mode="dtea:title.labelText">
        <xsl:value-of select="@dtea:title-label"/>
    </xsl:template>

    <xsl:function name="dtea:title.labelText">

        <xsl:param name="element"/>

        <xsl:apply-templates select="$element" mode="dtea:title.labelText"/>

    </xsl:function>


    <xsl:template match="*" mode="dtea:title.label">
        <span class="inline title_label">
            <xsl:value-of select="dtea:title.labelText(.)"/>
        </span>
    </xsl:template>

    <!-- Cross-reference label, e.g. Tbl. 24 -->

    <xsl:template match="*" mode="dtea:crossref.hasLabel">
        <xsl:sequence select="false()"/>
    </xsl:template>

    <xsl:template match="*[@dtea:crossref-label]" mode="dtea:crossref.hasLabel">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:function name="dtea:crossref.hasLabel" as="xs:boolean">

        <xsl:param name="element"/>

        <xsl:apply-templates select="$element" mode="dtea:crossref.hasLabel"/>

    </xsl:function>

    <xsl:template match="*" mode="dtea:crossref.labelText">
        <xsl:value-of select="@dtea:crossref-label"/>
    </xsl:template>

    <xsl:function name="dtea:crossref.labelText">

        <xsl:param name="element"/>

        <xsl:apply-templates select="$element" mode="dtea:crossref.labelText"/>

    </xsl:function>

    <xsl:template match="*" mode="dtea:crossref.label">
        <span class="inline _label">
            <xsl:value-of select="dtea:crossref.labelText(.)"/>
        </span>
    </xsl:template>

    <!-- Title wording, e. g. Reproduction of crustaceans -->

    <xsl:template match="*" mode="dtea:title.wordingText">
        <xsl:value-of select="*[dtea:isTitle(.)]"/>
    </xsl:template>

    <xsl:template match="*[dtea:isTitle(.)]" mode="dtea:title.wordingText">
        <xsl:value-of select="."/>
    </xsl:template>

    <xsl:function name="dtea:title.wordingText">

        <xsl:param name="element"/>

        <xsl:apply-templates select="$element" mode="dtea:title.wordingText"/>

    </xsl:function>

    <xsl:template match="*" mode="dtea:title.wording">
        <span class="inline title_wording">
            <xsl:apply-templates select="." mode="dtea:title.wordingText"/>
        </span>
    </xsl:template>

    <!-- Separator, e.g. : -->

    <xsl:template match="*" mode="dtea:title.separatorText">
        <xsl:value-of select="' &#8212; '"/>
    </xsl:template>

    <xsl:template match="*" mode="dtea:title.separator">
        <span class="inline title_separator">
            <xsl:value-of select="dtea:title.separatorText(.)"/>
        </span>
    </xsl:template>

    <xsl:function name="dtea:title.separatorText">

        <xsl:param name="element"/>

        <xsl:apply-templates select="$element" mode="dtea:title.separatorText"/>

    </xsl:function>


    <!-- Entire title content, e.g. Table 24: Reproduction of crustaceans -->

    <xsl:template match="*" mode="dtea:title.content">

        <xsl:if test="dtea:title.hasLabel(.)">
            <xsl:apply-templates select="." mode="dtea:title.label"/>
            <xsl:apply-templates select="." mode="dtea:title.separator"/>
        </xsl:if>

        <xsl:apply-templates select="." mode="dtea:title.wording"/>

    </xsl:template>


    <!-- 
        Being a target of cross-references
    -->

    <xsl:template match="*" mode="dtea:crossref.separatorText">
        <xsl:value-of select="' &#8212; '"/>
    </xsl:template>

    <xsl:function name="dtea:crossref.separatorText">

        <xsl:param name="element"/>

        <xsl:apply-templates select="$element" mode="dtea:crossref.separatorText"/>

    </xsl:function>

    <xsl:template match="*" mode="dtea:crossref.separator">
        <span class="inline title_separator">
            <xsl:value-of select="dtea:crossref.separatorText(.)"/>
        </span>
    </xsl:template>

    <!-- ID to be used by cross-references in the output document to point to the element -->

    <xsl:template match="*" mode="dtea:crossref.exposedId">
        <xsl:value-of select="dtea:outId(.)"/>
    </xsl:template>

    <xsl:function name="dtea:crossref.exposedId">

        <xsl:param name="element"/>

        <xsl:apply-templates select="$element" mode="dtea:crossref.exposedId"/>

    </xsl:function>

    <xsl:function name="dtea:crossref.exposedIdById">

        <xsl:param name="id"/>
        <xsl:param name="docRoot"/>

        <xsl:variable name="fastExposedId"
            select="dtea:enumerate.entryById($id, $docRoot)/@exposedId"/>

        <xsl:choose>

            <xsl:when test="$fastExposedId != ''">
                <xsl:value-of select="$fastExposedId"/>
            </xsl:when>

            <xsl:otherwise>
                <xsl:value-of select="dtea:crossref.exposedId($docRoot//*[@id = $id])"/>
            </xsl:otherwise>

        </xsl:choose>

    </xsl:function>

    <!-- Entire cross-reference content -->

    <xsl:template match="*" mode="dtea:crossref.wording"/>

    <xsl:template match="*" mode="dtea:crossref.exposedContent">

        <xsl:if test="dtea:crossref.hasLabel(.)">
            <xsl:apply-templates select="." mode="dtea:crossref.label"/>
            <xsl:apply-templates select="." mode="dtea:crossref.separator"/>
        </xsl:if>

        <xsl:apply-templates select="." mode="dtea:crossref.wording"/>

    </xsl:template>


    <xsl:template name="dtea:crossref.exposedContentById">

        <xsl:param name="id"/>
        <xsl:param name="docRoot"/>

        <xsl:variable name="entry" select="dtea:enumerate.entryById($id, $docRoot)"/>

        <xsl:choose>

            <xsl:when test="exists($entry/@idref)">
                <xsl:copy-of select="$entry/dtea:exposedContent/node()"/>
            </xsl:when>

            <xsl:otherwise>
                <xsl:apply-templates select="$docRoot//*[@id = $id]"
                    mode="dtea:crossref.exposedContent"/>
            </xsl:otherwise>

        </xsl:choose>

    </xsl:template>

</xsl:stylesheet>
