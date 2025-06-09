<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:dtea="http://itsurim.com/dtea"
    xmlns:xat="http://itsurim.com/xatool"
    xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
    exclude-result-prefixes="dita-ot dtea xat xs" version="2.0">


    <xsl:import href="../../queries/queries.xsl"/>


    <!-- 
        Detecting blocks for demixing purposes
    -->

    <xsl:template match="node()" mode="dtea:demix.isBlock" as="xs:boolean">
        <xsl:value-of select="dtea:isBlock(.)"/>
    </xsl:template>

    <xsl:function name="dtea:demix.isBlock" as="xs:boolean">
        <xsl:param name="node"/>
        <xsl:apply-templates select="$node" mode="dtea:demix.isBlock"/>
    </xsl:function>


    <!-- 
        Detecting inlines for demixing purposes
    -->

    <xsl:template match="node()" mode="dtea:demix.isInline" as="xs:boolean">
        <xsl:value-of select="dtea:isInline(.)"/>
    </xsl:template>

    <xsl:function name="dtea:demix.isInline" as="xs:boolean">
        <xsl:param name="node"/>
        <xsl:apply-templates select="$node" mode="dtea:demix.isInline"/>
    </xsl:function>


    <!-- 
        Detecting containers for demixing purposes
    -->

    <xsl:template match="*" mode="dtea:demix.isContainer" as="xs:boolean">
        <xsl:value-of select="false()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/p ')]" mode="dtea:demix.isContainer"
        as="xs:boolean">
        <xsl:value-of select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/li ') and not(contains(@class, ' task/'))]"
        mode="dtea:demix.isContainer" as="xs:boolean">
        <xsl:value-of select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/entry ')]" mode="dtea:demix.isContainer"
        as="xs:boolean">
        <xsl:value-of select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/stentry ')]" mode="dtea:demix.isContainer"
        as="xs:boolean">
        <xsl:value-of select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/note ')]" mode="dtea:demix.isContainer"
        as="xs:boolean">
        <xsl:value-of select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/section ')]" mode="dtea:demix.isContainer"
        as="xs:boolean">
        <xsl:value-of select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/itemgroup ')]" mode="dtea:demix.isContainer"
        as="xs:boolean">
        <xsl:value-of select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/div ')]" mode="dtea:demix.isContainer"
        as="xs:boolean">
        <xsl:value-of select="true()"/>
    </xsl:template>

    <xsl:function name="dtea:demix.isContainer" as="xs:boolean">
        <xsl:param name="node"/>
        <xsl:apply-templates select="$node" mode="dtea:demix.isContainer"/>
    </xsl:function>


    <!-- 
        Detecting containers that include mixed content
    -->

    <xsl:template match="node()[name() = '']" mode="dtea:demix.isMixed" as="xs:boolean">
        <xsl:value-of select="false()"/>
    </xsl:template>

    <xsl:template match="*" mode="dtea:demix.isMixed" as="xs:boolean">
        <xsl:sequence
            select="exists(*[dtea:demix.isBlock(.)]) and exists(node()[dtea:demix.isInline(.)])"/>
    </xsl:template>

    <xsl:function name="dtea:demix.isMixed" as="xs:boolean">

        <xsl:param name="element"/>

        <xsl:apply-templates select="$element" mode="dtea:demix.isMixed"/>

    </xsl:function>


    <!-- 
        Detecting and wrapping inline nodes
    -->

    <xsl:function name="dtea:demix.followingBlockId">

        <xsl:param name="node"/>

        <xsl:value-of select="generate-id(($node/following-sibling::*[dtea:demix.isBlock(.)])[1])"/>

    </xsl:function>


    <xsl:function name="dtea:demix.hasPrecedingInlines" as="xs:boolean">

        <xsl:param name="block"/>

        <xsl:variable name="bid" select="generate-id($block)"/>

        <xsl:sequence
            select="exists($block/preceding-sibling::node()[dtea:demix.isInline(.) and dtea:demix.followingBlockId(.) = $bid and not(name() = '' and normalize-space(.) = '')])"/>

    </xsl:function>


    <xsl:function name="dtea:demix.precedingBlockId">

        <xsl:param name="node"/>

        <xsl:value-of
            select="generate-id(($node/preceding-sibling::*[dtea:demix.isBlock(.)])[last()])"/>

    </xsl:function>


    <xsl:function name="dtea:demix.hasFollowingInlines" as="xs:boolean">

        <xsl:param name="block"/>

        <xsl:variable name="bid" select="generate-id($block)"/>

        <xsl:sequence
            select="exists($block/following-sibling::node()[dtea:demix.isInline(.) and dtea:demix.precedingBlockId(.) = $bid and not(name() = '' and normalize-space(.) = '')])"/>

    </xsl:function>


    <xsl:template match="*" mode="dtea:demix.precedingInlines">

        <xsl:variable name="cid" select="generate-id(.)"/>

        <foreign class="- dtea/demixed ">
            <xsl:choose>
                <xsl:when
                    test="preceding-sibling::*[dtea:demix.isInline(.) and dtea:demix.followingBlockId(.) = $cid]">
                    <xsl:copy-of
                        select="preceding-sibling::node()[dtea:demix.isInline(.) and dtea:demix.followingBlockId(.) = $cid]"
                    />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:variable name="rawText">
                        <xsl:value-of
                            select="preceding-sibling::node()[dtea:demix.isInline(.) and dtea:demix.followingBlockId(.) = $cid]"
                        />
                    </xsl:variable>
                    <xsl:value-of select="normalize-space($rawText)"/>
                </xsl:otherwise>
            </xsl:choose>
        </foreign>

    </xsl:template>


    <xsl:template match="*" mode="dtea:demix.followingInlines">

        <xsl:variable name="cid" select="generate-id(.)"/>

        <foreign class="- xatool/demixed ">
            <xsl:choose>
                <xsl:when
                    test="following-sibling::*[dtea:demix.isInline(.) and dtea:demix.precedingBlockId(.) = $cid]">
                    <xsl:copy-of
                        select="following-sibling::node()[dtea:demix.isInline(.) and dtea:demix.precedingBlockId(.) = $cid]"
                    />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:variable name="rawText">
                        <xsl:value-of
                            select="following-sibling::node()[dtea:demix.isInline(.) and dtea:demix.precedingBlockId(.) = $cid]"
                        />
                    </xsl:variable>
                    <xsl:value-of select="normalize-space($rawText)"/>
                </xsl:otherwise>
            </xsl:choose>
        </foreign>

    </xsl:template>


    <!-- 
        Wrapping inlines mixed up with blocks
    -->

    <xsl:template match="*" mode="dtea:demix.inner">

        <xsl:for-each select="*[dtea:demix.isBlock(.)]">

            <xsl:if test="dtea:demix.hasPrecedingInlines(.)">
                <xsl:apply-templates select="." mode="dtea:demix.precedingInlines"/>
            </xsl:if>

            <xsl:apply-templates select="." mode="dtea:demix.wrapInlines"/>

            <xsl:if
                test="not(exists(following-sibling::*[dtea:demix.isBlock(.)])) and dtea:demix.hasFollowingInlines(.)">
                <xsl:apply-templates select="." mode="dtea:demix.followingInlines"/>
            </xsl:if>

        </xsl:for-each>

    </xsl:template>


    <xsl:template match="*[dtea:demix.isContainer(.) and dtea:demix.isMixed(.)]"
        mode="dtea:demix.wrapInlines">

        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates select="." mode="dtea:demix.inner"/>
        </xsl:copy>

    </xsl:template>


    <xsl:template match="node()" mode="dtea:demix.wrapInlines">

        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates select="node()" mode="#current"/>
        </xsl:copy>

    </xsl:template>


    <!-- 
        Simplifying redundant containers
    -->

    <xsl:template match="node()" mode="dtea:demix.isRedundantContainer" as="xs:boolean">
        <xsl:sequence select="false()"/>
    </xsl:template>

    <xsl:template match="p" mode="dtea:demix.isRedundantContainer" as="xs:boolean">

        <xsl:param name="inner"/>

        <xsl:choose>
            <xsl:when test="@outputclass">
                <xsl:sequence select="false()"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="not(exists(node()[not(dtea:demix.isBlock(.))]))"/>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <xsl:function name="dtea:demix.isRedundantContainer" as="xs:boolean">

        <xsl:param name="container"/>

        <xsl:apply-templates select="$container" mode="dtea:demix.isRedundantContainer"/>

    </xsl:function>


    <xsl:template match="node()" mode="dtea:demix.simplifyContainers">

        <xsl:choose>

            <xsl:when test="dtea:demix.isRedundantContainer(.)">
                <xsl:apply-templates select="*" mode="#current"/>
            </xsl:when>

            <xsl:otherwise>
                <xsl:copy>
                    <xsl:copy-of select="@*"/>
                    <xsl:apply-templates select="node()" mode="#current"/>
                </xsl:copy>
            </xsl:otherwise>

        </xsl:choose>

    </xsl:template>


    <!-- 
        Entire processing
    -->

    <xsl:template match="*" mode="dtea:demix">

        <xsl:variable name="wrapped">
            <xsl:apply-templates select="." mode="dtea:demix.wrapInlines"/>
        </xsl:variable>
        
        <xsl:apply-templates select="$wrapped/*" mode="dtea:demix.simplifyContainers"/>
       
    </xsl:template>

</xsl:stylesheet>