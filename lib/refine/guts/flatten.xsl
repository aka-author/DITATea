<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:loc="http://itsurim.com/local" xmlns:dtea="http://itsurim.com/dtea"
    xmlns:xat="http://itsurim.com/xatool" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="dtea loc xat xs" version="2.0">


    <xsl:import href="../../../xatool/utils/xsl-2.0/pathuri.xsl"/>

    <xsl:import href="../../queries/queries.xsl"/>


    <!-- Constructing unique page file names -->

    <xsl:function name="dtea:flatten.Base">
        <xsl:param name="xtrf"/>
        <xsl:variable name="items" select="tokenize($xtrf, '\\|/')"/>
        <xsl:variable name="fileName" select="$items[count($items)]"/>
        <xsl:value-of select="substring-before($fileName, '.')"/>
    </xsl:function>


    <xsl:template match="@* | node()" mode="dtea:flatten.annotate">

        <xsl:copy>
            <xsl:if test="not(exists(@id))">
                <xsl:attribute name="id" select="generate-id()"/>
            </xsl:if>
            <xsl:if test="dtea:isTopic(.)">
                <xsl:attribute name="topicFileName" select="lower-case(dtea:flatten.Base(@xtrf))"/>
            </xsl:if>
            <xsl:apply-templates select="@* | node()" mode="dtea:flatten.annotate"/>
        </xsl:copy>

    </xsl:template>


    <xsl:template match="*" mode="dtea:flatten.PageNameGroups">

        <topicFileNameGroups>
            <xsl:for-each-group select="//*[@topicFileName != '']" group-by="@topicFileName">
                <topicFileNameGroup topicFileName="{@topicFileName}">
                    <xsl:variable name="topicFileName" select="@topicFileName"/>
                    <xsl:for-each select="//*[@topicFileName = $topicFileName]">
                        <page>
                            <xsl:copy-of select="@id"/>
                            <xsl:copy-of select="@topicFileName"/>
                        </page>
                    </xsl:for-each>
                </topicFileNameGroup>
            </xsl:for-each-group>
        </topicFileNameGroups>

    </xsl:template>


    <xsl:template match="topicFileNameGroups" mode="dtea:flatten.PageFileNames">

        <flatPageFileNames>
            <xsl:for-each select="topicFileNameGroup">
                <xsl:for-each select="page">
                    <xsl:variable name="idx" select="count(preceding-sibling::*)"/>
                    <page>
                        <xsl:variable name="suffix">
                            <xsl:if test="$idx &gt; 0">
                                <xsl:value-of select="concat('-', $idx)"/>
                            </xsl:if>
                        </xsl:variable>
                        <xsl:copy-of select="@id"/>
                        <xsl:attribute name="fileName" select="concat(@topicFileName, $suffix)"/>
                    </page>
                </xsl:for-each>
            </xsl:for-each>
        </flatPageFileNames>

    </xsl:template>


    <xsl:template match="*" mode="dtea:flatten.rules">

        <xsl:variable name="pageGroupedByFileName">
            <xsl:apply-templates select="." mode="dtea:flatten.PageNameGroups"/>
        </xsl:variable>

        <flattenRules>
            <xsl:apply-templates select="$pageGroupedByFileName/*" mode="dtea:flatten.PageFileNames"
            />
        </flattenRules>

    </xsl:template>


    <xsl:template match="*" mode="dtea:flatten.image.href">
        <xsl:value-of select="@href"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/image ')]" mode="dtea:flatten.parse">

        <xsl:element name="{name()}">

            <xsl:copy-of select="@*[name() != 'href']"/>

            <xsl:attribute name="href">
                <xsl:apply-templates select="." mode="dtea:flatten.image.href"/>
            </xsl:attribute>

            <xsl:copy-of select="node()"/>

        </xsl:element>

    </xsl:template>


    <xsl:template match="@* | node()" mode="dtea:flatten.parse">
        
        <xsl:param name="flattenRules"/>

        <xsl:copy>

            <xsl:if test="dtea:isTopic(.)">
                <xsl:attribute name="pageFileName">
                    <xsl:value-of select="$flattenRules//page[@id = current()/@id]/@fileName"/>
                </xsl:attribute>
            </xsl:if>

            <xsl:apply-templates select="@* | node()" mode="dtea:flatten.parse">
                <xsl:with-param name="flattenRules" select="$flattenRules"/>
            </xsl:apply-templates>

        </xsl:copy>

    </xsl:template>


    <xsl:template match="*" mode="dtea:flatten">

        <xsl:variable name="annotated">
            <xsl:apply-templates select="." mode="dtea:flatten.annotate"/>
        </xsl:variable>

        <xsl:variable name="flattenRules">
            <xsl:apply-templates select="$annotated/*" mode="dtea:flatten.rules"/>
        </xsl:variable>

        <xsl:apply-templates select="$annotated/*" mode="dtea:flatten.parse">
            <xsl:with-param name="flattenRules" select="$flattenRules"/>
        </xsl:apply-templates>

    </xsl:template>


    <!-- Retrieving unique page file names -->

    <xsl:template match="*" mode="dtea:flatten.hasOwnContent" as="xs:boolean">
        <xsl:sequence select="@pageFileName != ''"/>
    </xsl:template>

    <xsl:function name="dtea:flatten.hasOwnContent" as="xs:boolean">
        <xsl:param name="topic"/>
        <xsl:apply-templates select="$topic" mode="dtea:flatten.hasOwnContent"/>
    </xsl:function>


    <xsl:template match="*" mode="dtea:flatten.uniquePageFileNameBase">

        <xsl:choose>
            <xsl:when test="empty(@pageFileName)">
                <xsl:value-of select="generate-id(.)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="@pageFileName"/>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <xsl:template match="*[not(dtea:flatten.hasOwnContent(.))]"
        mode="dtea:flatten.uniquePageFileNameBase">
        <xsl:value-of select="generate-id(.)"/>
    </xsl:template>

    <xsl:function name="dtea:flatten.uniquePageFileNameBase" as="xs:string">
        <xsl:param name="topic" as="element(*)"/>
        <xsl:apply-templates select="$topic" mode="dtea:flatten.uniquePageFileNameBase"/>
    </xsl:function>

</xsl:stylesheet>
