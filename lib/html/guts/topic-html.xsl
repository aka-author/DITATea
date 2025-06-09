<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dtea="http://itsurim.com/dtea" xmlns:xat="http://itsurim.com/xatool"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="dtea xat xs" version="2.0">


    <xsl:import href="../../queries/queries.xsl"/>


    <xsl:template match="*[dtea:isTopicTitle(.)]" mode="dtea:isBlock" as="xs:boolean">
        <xsl:sequence select="false()"/>
    </xsl:template>


    <xsl:template match="*[dtea:isTopicTitle(.)]" mode="dtea:level" as="xs:integer">
        <xsl:value-of select="dtea:level(..)"/>
    </xsl:template>
    

    <xsl:template match="*[dtea:isTopicTitle(.)]" mode="dtea:outElementName">
        
        <xsl:variable name="level" select="dtea:level(.) + 1"/>
            
        <xsl:value-of select="concat('h', if ($level &lt; 7) then $level else 6)"/>
        
    </xsl:template>
    
    
    <!-- <xsl:template match="*[dtea:isTopicTitle(.)]"> -->
        
    <xsl:template match="*[dtea:isTitle(.)]">
        
        <!--
        <xsl:variable name="headingElementName">
            <xsl:apply-templates select="." mode="dtea:outElementName"/>
        </xsl:variable>
        -->
        
        <!-- <xsl:element name="{$headingElementName}">-->
        <xsl:element name="{dtea:outElementName(.)}">
            <xsl:apply-templates select="." mode="dtea:outAttrs"/>
            <xsl:apply-templates select="." mode="dtea:title.content"/>
        </xsl:element>
        
    </xsl:template>
    
    
    <xsl:template match="*[dtea:isTopic(.)]" mode="dtea:html.minorTopics">
        
        <div class="topic_block minor_topics">
            <xsl:apply-templates select="*[dtea:isTopic(.)]"/>
        </div>
        
    </xsl:template>
    
    
    <xsl:template match="*[dtea:isTopic(.)]">

        <div>
            <xsl:apply-templates select="." mode="dtea:outAttrs"/>

            <xsl:apply-templates select="*[dtea:isTopicTitle(.)]"/>
            <xsl:apply-templates select="*[dtea:isBody(.)]"/>
            <xsl:apply-templates select="*[dtea:isRelatedLinksBlock(.)]"/>

            <xsl:if test="*[dtea:isTopic(.)]">
                <xsl:apply-templates select="." mode="dtea:html.minorTopics"/>
            </xsl:if>

        </div>

    </xsl:template>
    
    
    <xsl:template match="*[dtea:isBody(.)]" mode="dtea:outElementName">
        <xsl:value-of select="'div'"/>
    </xsl:template>

</xsl:stylesheet>